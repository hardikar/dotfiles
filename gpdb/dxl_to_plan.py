#! /usr/bin/env python
'''
The xml.etree.ElementTree module is not secure against maliciously constructed
data. If you need to parse untrusted or unauthenticated data see XML
vulnerabilities.
'''
from StringIO import StringIO
import xml.etree.ElementTree as et
from sys import argv

#FILE="/Users/shardikar/workspace/main/gporca/data/dxl/minidump/PartTbl-MultiWayJoinWithDPE.mdp"
ns = { 'dxl': 'http://greenplum.com/dxl' }

types = {}
funcs = {}
columns = {}
filters = ['JoinFilter', 'Filter', 'HashCondList', 'OneTimeFilter', 'PrintableFilter']
ignored = filters + ['ProjList', 'Properties', 'PartEqFilters', 'PartFilters', 'ResidualFilter', 'PropagationExpression']

def prefix(indent):
    return '    ' * indent + ' ' * len('->')
def prefix_node(indent):
    return '    ' * indent + '->'

def handle_filters(node, indent):
    for name in filters:
        elem = node.find(name)
        if elem is not None and len(elem) != 0:
            print prefix(indent), ' ', elem.tag, ':', recurse_expr(elem[0])

def recurse_node(node, indent=0):
    if 'Scan' in node.tag:
        scan_node(node, indent)
    elif 'Motion' in node.tag:
        motion_node(node, indent)
    elif node.tag in 'Aggregate':
        agg_node(node, indent)
    else:
        print prefix_node(indent), node.tag
        handle_filters(node, indent)
        for elem in node:
            if elem.tag not in ignored:
                recurse_node(elem, indent+1)


def recurse_expr(node):
    if node.tag == 'Ident':
        return node.get('ColName')
    elif node.tag == 'And':
        lhs = recurse_expr(node[0])
        rhs = recurse_expr(node[0])
        return '%s AND %s' % (lhs, rhs)
    elif node.tag == 'Or':
        lhs = recurse_expr(node[0])
        rhs = recurse_expr(node[0])
        return '%s OR %s' % (lhs, rhs)
    elif node.tag == 'Comparison':
        lhs = recurse_expr(node[0])
        rhs = recurse_expr(node[0])
        return '%s %s %s' % (lhs, node.get('ComparisonOperator'), rhs)
    elif node.tag == 'ConstValue':
        value = node.get('Value')
        typenode = types.get(node.get('TypeMdid'))
        typename = typenode.get('Name') if typenode is not None else ''
        return '"%s"::%s' % (value, typename)
    elif node.tag == 'FuncExpr':
        funcname = funcs.get(node.get('FuncId'), '???')
        args = [ recurse_expr(arg) for arg in list(node)]
        return '%s(%s)' % (funcname, ', '.join(args))
    elif node.tag == 'AggFunc':
        distinct = node.get('AggDistinct')
        funcname = funcs.get(node.get('AggMdid'), '???')
        args = [ recurse_expr(arg) for arg in list(node)]
        return '%s(%s%s)' % (funcname, 'DISTINCT ' if distinct else '', ', '.join(args))
    elif node.tag == 'GroupingColumn':
        return columns.get(node.get('ColId'))
    else:
        print node.tag

def motion_node(node, indent):
    input_segments = node.get('InputSegments').split(',')
    output_segments = node.get('OutputSegments').split(',')

    print prefix_node(indent), node.tag, '(%d:%d)' % (len(input_segments), len(output_segments))
    handle_filters(node, indent)
    recurse_node(node[-1], indent+1)

def scan_node(node, indent):
    tdesc = node.find('TableDescriptor')
    if tdesc is not None:
        name = tdesc.get('TableName')
    else:
        name = None
    print prefix_node(indent), node.tag, '"%s"' % name
    handle_filters(node, indent)

def agg_node(node, indent):
    projlist = node.find('ProjList')
    aggfuncs = []
    for elem in projlist.iter('AggFunc'):
        aggfuncs.append(recurse_expr(elem))
    print prefix_node(indent), node.tag, ', '.join(aggfuncs)
    grouping_columns = node.find('GroupingColumns')
    if grouping_columns is not None and len(grouping_columns) != 0:
        gcols = [recurse_expr(col) for col in grouping_columns]
        print prefix(indent), ' GroupingColumns', ':', ', '.join(gcols)
    recurse_node(node[-1], indent+1)

def parse_xml(path):
    # strip all namespace nonsense while parsing
    it = et.iterparse(path)
    for _, elem in it:
        if '}' in elem.tag:
            elem.tag = elem.tag.split('}', 1)[1]
    root = it.root
    return root


def parse_metadata(metadata):
    global types
    for child in metadata:
        if child.tag == 'Relation':
            pass
        elif child.tag == 'Type':
            types[child.get('Mdid')] = child
        elif 'Func' in child.tag or 'Agg' in child.tag:
            funcs[child.get('Mdid')] = child.get('Name')
        else:
            pass

def parse_columns(query, plan):
    for col in query.iter('Column'):
        colid = col.get('ColId')
        if colid not in columns:
            columns[colid] = col.get('ColName')
    for col in plan.iter('ProjElem'):
        colid = col.get('ColId')
        if colid not in columns:
            columns[colid] = col.get('Alias')

def convert_to_plan(path):
    root = parse_xml(path).find('Thread')
    
    config = root.find('OptimizerConfig')
    metadata = root.find('Metadata')
    query = root.find('Query')
    plan = root.find('Plan')

    parse_metadata(metadata)
    parse_columns(query, plan)
    recurse_node(plan[0])

def main():
    if len(argv) != 2:
        return
    convert_to_plan(path=argv[1])

if __name__ == '__main__':
    main()
