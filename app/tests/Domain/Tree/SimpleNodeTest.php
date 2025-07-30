<?php

declare(strict_types=1);

namespace App\Tests\Domain\Tree;

use App\Domain\Tree\SimpleNode;
use PHPUnit\Framework\TestCase;

class SimpleNodeTest extends TestCase
{
    public function testConstructorAndGetters(): void
    {
        $node = new SimpleNode('Test Node');
        
        $this->assertEquals('Test Node', $node->getName());
        $this->assertFalse($node->hasChildren());
        $this->assertEmpty($node->getChildren());
    }

    public function testConstructorWithButton(): void
    {
        $node = new SimpleNode('Test Node', true);
        
        $this->assertEquals('Test Node', $node->getName());
        $this->assertTrue($node->hasButton());
    }

    public function testAddChild(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        
        $parent->addChild($child);
        
        $this->assertTrue($parent->hasChildren());
        $this->assertCount(1, $parent->getChildren());
        $this->assertSame($child, $parent->getChildren()[0]);
    }

    public function testAddMultipleChildren(): void
    {
        $parent = new SimpleNode('Parent');
        $child1 = new SimpleNode('Child 1');
        $child2 = new SimpleNode('Child 2');
        
        $parent->addChild($child1);
        $parent->addChild($child2);
        
        $this->assertTrue($parent->hasChildren());
        $this->assertCount(2, $parent->getChildren());
        $this->assertSame($child1, $parent->getChildren()[0]);
        $this->assertSame($child2, $parent->getChildren()[1]);
    }

    public function testRenderWithoutChildren(): void
    {
        $node = new SimpleNode('Test Node');
        $html = $node->render();
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('<input type="checkbox">', $html);
        $this->assertStringContainsString('Test Node', $html);
        $this->assertStringNotContainsString('<ul>', $html);
    }

    public function testRenderWithButton(): void
    {
        $node = new SimpleNode('Test Node', true);
        $html = $node->render();
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('<input type="checkbox">', $html);
        $this->assertStringContainsString('Test Node', $html);
        $this->assertStringContainsString('<br/>', $html);
        $this->assertStringContainsString('<button>', $html);
        $this->assertStringContainsString('Test Btn', $html);
    }

    public function testRenderWithChildren(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        $parent->addChild($child);
        
        $html = $parent->render();
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('<ul>', $html);
        $this->assertStringContainsString('<li>', $html);
        $this->assertStringContainsString('Child', $html);
    }

    public function testRenderWithMultipleChildren(): void
    {
        $parent = new SimpleNode('Parent');
        $child1 = new SimpleNode('Child 1');
        $child2 = new SimpleNode('Child 2');
        
        $parent->addChild($child1);
        $parent->addChild($child2);
        
        $html = $parent->render();
        
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Child 1', $html);
        $this->assertStringContainsString('Child 2', $html);
        $this->assertEquals(2, substr_count($html, '<li>'));
    }

    public function testRenderWithNestedChildren(): void
    {
        $root = new SimpleNode('Root');
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        
        $parent->addChild($child);
        $root->addChild($parent);
        
        $html = $root->render();
        
        $this->assertStringContainsString('Root', $html);
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Child', $html);
        $this->assertEquals(2, substr_count($html, '<ul>'));
    }

    public function testHtmlEscaping(): void
    {
        $node = new SimpleNode('<script>alert("xss")</script>');
        $html = $node->render();
        
        $this->assertStringContainsString('&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;', $html);
        $this->assertStringNotContainsString('<script>', $html);
    }

    public function testEmptyChildrenArray(): void
    {
        $node = new SimpleNode('Test');
        
        $this->assertEmpty($node->getChildren());
        $this->assertFalse($node->hasChildren());
    }

    public function testHasChildrenAfterAddingAndRemoving(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        
        $this->assertFalse($parent->hasChildren());
        
        $parent->addChild($child);
        $this->assertTrue($parent->hasChildren());
        
        // Note: We don't have a remove method, but we can test the current behavior
        $this->assertCount(1, $parent->getChildren());
    }
} 