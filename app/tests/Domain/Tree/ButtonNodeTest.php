<?php

declare(strict_types=1);

namespace App\Tests\Domain\Tree;

use App\Domain\Tree\ButtonNode;
use PHPUnit\Framework\TestCase;

class ButtonNodeTest extends TestCase
{
    public function testConstructorAndGetters(): void
    {
        $node = new ButtonNode('Test Node', 'Click Me', 'alert("test")');
        
        $this->assertEquals('Test Node', $node->getName());
        $this->assertEquals('button', $node->getType());
        $this->assertEquals('Click Me', $node->getButtonText());
        $this->assertEquals('alert("test")', $node->getButtonAction());
        $this->assertFalse($node->hasChildren());
        $this->assertEmpty($node->getChildren());
    }

    public function testConstructorWithDefaults(): void
    {
        $node = new ButtonNode('Test Node');
        
        $this->assertEquals('Test Node', $node->getName());
        $this->assertEquals('button', $node->getType());
        $this->assertEquals('Test Btn', $node->getButtonText());
        $this->assertEquals('', $node->getButtonAction());
    }

    public function testAddChild(): void
    {
        $parent = new ButtonNode('Parent', 'Parent Button');
        $child = new ButtonNode('Child', 'Child Button');
        
        $parent->addChild($child);
        
        $this->assertTrue($parent->hasChildren());
        $this->assertCount(1, $parent->getChildren());
        $this->assertSame($child, $parent->getChildren()[0]);
    }

    public function testAddMultipleChildren(): void
    {
        $parent = new ButtonNode('Parent', 'Parent Button');
        $child1 = new ButtonNode('Child 1', 'Button 1');
        $child2 = new ButtonNode('Child 2', 'Button 2');
        
        $parent->addChild($child1);
        $parent->addChild($child2);
        
        $this->assertTrue($parent->hasChildren());
        $this->assertCount(2, $parent->getChildren());
        $this->assertSame($child1, $parent->getChildren()[0]);
        $this->assertSame($child2, $parent->getChildren()[1]);
    }

    public function testEmptyChildrenArray(): void
    {
        $node = new ButtonNode('Test', 'Test Button');
        
        $this->assertEmpty($node->getChildren());
        $this->assertFalse($node->hasChildren());
    }

    public function testHasChildrenAfterAdding(): void
    {
        $parent = new ButtonNode('Parent', 'Parent Button');
        $child = new ButtonNode('Child', 'Child Button');
        
        $this->assertFalse($parent->hasChildren());
        
        $parent->addChild($child);
        $this->assertTrue($parent->hasChildren());
        
        $this->assertCount(1, $parent->getChildren());
    }
} 