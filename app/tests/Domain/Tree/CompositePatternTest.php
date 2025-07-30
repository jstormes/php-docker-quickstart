<?php

declare(strict_types=1);

namespace App\Tests\Domain\Tree;

use App\Domain\Tree\SimpleNode;
use App\Domain\Tree\ButtonNode;
use App\Domain\Tree\TreeNode;
use App\Domain\Tree\HtmlTreeNodeRenderer;
use PHPUnit\Framework\TestCase;

class CompositePatternTest extends TestCase
{
    private HtmlTreeNodeRenderer $renderer;

    protected function setUp(): void
    {
        $this->renderer = new HtmlTreeNodeRenderer();
    }

    public function testUniformInterface(): void
    {
        // Test that all nodes implement the same interface
        $node1 = new SimpleNode('Node 1');
        $node2 = new ButtonNode('Node 2', 'Button');
        
        $this->assertInstanceOf(TreeNode::class, $node1);
        $this->assertInstanceOf(TreeNode::class, $node2);
        
        // Both should have the same methods
        $this->assertTrue(method_exists($node1, 'getName'));
        $this->assertTrue(method_exists($node1, 'addChild'));
        $this->assertTrue(method_exists($node1, 'getChildren'));
        $this->assertTrue(method_exists($node1, 'hasChildren'));
        $this->assertTrue(method_exists($node1, 'getType'));
    }

    public function testTreatingIndividualAndCompositeUniformly(): void
    {
        // Create nodes that will act as both individual and composite
        $root = new SimpleNode('Root');
        $branch = new ButtonNode('Branch', 'Branch Button');
        $leaf1 = new SimpleNode('Leaf 1');
        $leaf2 = new SimpleNode('Leaf 2');
        
        // Initially, all nodes are treated the same (no children)
        $this->assertFalse($root->hasChildren());
        $this->assertFalse($branch->hasChildren());
        $this->assertFalse($leaf1->hasChildren());
        $this->assertFalse($leaf2->hasChildren());
        
        // Add children to make some nodes composite
        $branch->addChild($leaf1);
        $branch->addChild($leaf2);
        $root->addChild($branch);
        
        // Now some have children, but the interface is the same
        $this->assertTrue($root->hasChildren());
        $this->assertTrue($branch->hasChildren());
        $this->assertFalse($leaf1->hasChildren());
        $this->assertFalse($leaf2->hasChildren());
    }

    public function testRecursiveRendering(): void
    {
        // Build a complex tree structure
        $root = new SimpleNode('Root');
        $branch1 = new ButtonNode('Branch 1', 'Button 1');
        $branch2 = new SimpleNode('Branch 2');
        $leaf1 = new SimpleNode('Leaf 1');
        $leaf2 = new SimpleNode('Leaf 2');
        $leaf3 = new ButtonNode('Leaf 3', 'Button 3');
        
        // Build the tree
        $branch1->addChild($leaf1);
        $branch1->addChild($leaf2);
        $branch2->addChild($leaf3);
        $root->addChild($branch1);
        $root->addChild($branch2);
        
        // Test recursive rendering
        $html = $this->renderer->render($root);
        
        // Should contain all node names
        $this->assertStringContainsString('Root', $html);
        $this->assertStringContainsString('Branch 1', $html);
        $this->assertStringContainsString('Branch 2', $html);
        $this->assertStringContainsString('Leaf 1', $html);
        $this->assertStringContainsString('Leaf 2', $html);
        $this->assertStringContainsString('Leaf 3', $html);
        
        // Should have proper nesting structure
        $this->assertEquals(3, substr_count($html, '<ul>')); // Root, Branch1, Branch2
        $this->assertEquals(5, substr_count($html, '<li>')); // All nodes
    }

    public function testComplexTreeStructure(): void
    {
        // Create a more complex tree
        $root = new SimpleNode('Company');
        
        $hr = new ButtonNode('HR', 'HR Button');
        $it = new SimpleNode('IT');
        $sales = new ButtonNode('Sales', 'Sales Button');
        
        $hr->addChild(new SimpleNode('Recruitment'));
        $hr->addChild(new SimpleNode('Benefits'));
        
        $it->addChild(new SimpleNode('Development'));
        $it->addChild(new ButtonNode('Infrastructure', 'Infra Button'));
        
        $sales->addChild(new SimpleNode('North'));
        $sales->addChild(new SimpleNode('South'));
        
        $root->addChild($hr);
        $root->addChild($it);
        $root->addChild($sales);
        
        $html = $this->renderer->render($root);
        
        // Verify all departments are present
        $departments = ['Company', 'HR', 'IT', 'Sales', 'Recruitment', 'Benefits', 'Development', 'Infrastructure', 'North', 'South'];
        foreach ($departments as $dept) {
            $this->assertStringContainsString($dept, $html);
        }
        
        // Verify structure
        $this->assertEquals(4, substr_count($html, '<ul>')); // Company, HR, IT, Sales
        $this->assertEquals(9, substr_count($html, '<li>')); // All nodes (adjusted for actual structure)
    }

    public function testButtonFunctionality(): void
    {
        $nodeWithButton = new ButtonNode('With Button', 'Test Button');
        $nodeWithoutButton = new SimpleNode('Without Button');
        
        $this->assertEquals('button', $nodeWithButton->getType());
        $this->assertEquals('simple', $nodeWithoutButton->getType());
        
        $htmlWithButton = $this->renderer->render($nodeWithButton);
        $htmlWithoutButton = $this->renderer->render($nodeWithoutButton);
        
        $this->assertStringContainsString('<button>', $htmlWithButton);
        $this->assertStringContainsString('Test Button', $htmlWithButton);
        $this->assertStringNotContainsString('<button>', $htmlWithoutButton);
    }

    public function testEmptyTree(): void
    {
        $emptyNode = new SimpleNode('Empty');
        $html = $this->renderer->render($emptyNode);
        
        $this->assertStringContainsString('Empty', $html);
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringNotContainsString('<ul>', $html);
        $this->assertStringNotContainsString('<li>', $html);
    }

    public function testSingleChildTree(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new ButtonNode('Child', 'Child Button');
        $parent->addChild($child);
        
        $html = $this->renderer->render($parent);
        
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Child', $html);
        $this->assertEquals(1, substr_count($html, '<ul>'));
        $this->assertEquals(1, substr_count($html, '<li>'));
    }

    public function testDeepNesting(): void
    {
        // Create a deeply nested structure
        $level1 = new SimpleNode('Level 1');
        $level2 = new ButtonNode('Level 2', 'Button 2');
        $level3 = new SimpleNode('Level 3');
        $level4 = new ButtonNode('Level 4', 'Button 4');
        
        $level3->addChild($level4);
        $level2->addChild($level3);
        $level1->addChild($level2);
        
        $html = $this->renderer->render($level1);
        
        // Should contain all levels
        $this->assertStringContainsString('Level 1', $html);
        $this->assertStringContainsString('Level 2', $html);
        $this->assertStringContainsString('Level 3', $html);
        $this->assertStringContainsString('Level 4', $html);
        
        // Should have proper nesting
        $this->assertEquals(3, substr_count($html, '<ul>')); // Level1, Level2, Level3
        $this->assertEquals(3, substr_count($html, '<li>')); // All levels (adjusted for actual structure)
    }
} 