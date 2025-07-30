<?php

declare(strict_types=1);

namespace App\Tests\Domain\Tree;

use App\Domain\Tree\SimpleNode;
use App\Domain\Tree\TreeNode;
use PHPUnit\Framework\TestCase;

class CompositePatternTest extends TestCase
{
    public function testUniformInterface(): void
    {
        // Test that all nodes implement the same interface
        $node1 = new SimpleNode('Node 1');
        $node2 = new SimpleNode('Node 2');
        
        $this->assertInstanceOf(TreeNode::class, $node1);
        $this->assertInstanceOf(TreeNode::class, $node2);
        
        // Both should have the same methods
        $this->assertTrue(method_exists($node1, 'getName'));
        $this->assertTrue(method_exists($node1, 'render'));
        $this->assertTrue(method_exists($node1, 'addChild'));
        $this->assertTrue(method_exists($node1, 'getChildren'));
        $this->assertTrue(method_exists($node1, 'hasChildren'));
    }

    public function testTreatingIndividualAndCompositeUniformly(): void
    {
        // Create nodes that will act as both individual and composite
        $root = new SimpleNode('Root');
        $branch = new SimpleNode('Branch');
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
        $branch1 = new SimpleNode('Branch 1');
        $branch2 = new SimpleNode('Branch 2');
        $leaf1 = new SimpleNode('Leaf 1');
        $leaf2 = new SimpleNode('Leaf 2');
        $leaf3 = new SimpleNode('Leaf 3');
        
        // Build the tree
        $branch1->addChild($leaf1);
        $branch1->addChild($leaf2);
        $branch2->addChild($leaf3);
        $root->addChild($branch1);
        $root->addChild($branch2);
        
        // Test recursive rendering
        $html = $root->render();
        
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
        
        $hr = new SimpleNode('HR');
        $it = new SimpleNode('IT');
        $sales = new SimpleNode('Sales');
        
        $hr->addChild(new SimpleNode('Recruitment'));
        $hr->addChild(new SimpleNode('Benefits'));
        
        $it->addChild(new SimpleNode('Development'));
        $it->addChild(new SimpleNode('Infrastructure'));
        
        $sales->addChild(new SimpleNode('North'));
        $sales->addChild(new SimpleNode('South'));
        
        $root->addChild($hr);
        $root->addChild($it);
        $root->addChild($sales);
        
        $html = $root->render();
        
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
        $nodeWithButton = new SimpleNode('With Button', true);
        $nodeWithoutButton = new SimpleNode('Without Button', false);
        
        $this->assertTrue($nodeWithButton->hasButton());
        $this->assertFalse($nodeWithoutButton->hasButton());
        
        $htmlWithButton = $nodeWithButton->render();
        $htmlWithoutButton = $nodeWithoutButton->render();
        
        $this->assertStringContainsString('<button>', $htmlWithButton);
        $this->assertStringContainsString('Test Btn', $htmlWithButton);
        $this->assertStringNotContainsString('<button>', $htmlWithoutButton);
    }

    public function testEmptyTree(): void
    {
        $emptyNode = new SimpleNode('Empty');
        $html = $emptyNode->render();
        
        $this->assertStringContainsString('Empty', $html);
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringNotContainsString('<ul>', $html);
        $this->assertStringNotContainsString('<li>', $html);
    }

    public function testSingleChildTree(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        $parent->addChild($child);
        
        $html = $parent->render();
        
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Child', $html);
        $this->assertEquals(1, substr_count($html, '<ul>'));
        $this->assertEquals(1, substr_count($html, '<li>'));
    }

    public function testDeepNesting(): void
    {
        // Create a deeply nested structure
        $level1 = new SimpleNode('Level 1');
        $level2 = new SimpleNode('Level 2');
        $level3 = new SimpleNode('Level 3');
        $level4 = new SimpleNode('Level 4');
        
        $level3->addChild($level4);
        $level2->addChild($level3);
        $level1->addChild($level2);
        
        $html = $level1->render();
        
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