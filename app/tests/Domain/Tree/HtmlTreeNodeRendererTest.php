<?php

declare(strict_types=1);

namespace App\Tests\Domain\Tree;

use App\Domain\Tree\SimpleNode;
use App\Domain\Tree\ButtonNode;
use App\Domain\Tree\HtmlTreeNodeRenderer;
use PHPUnit\Framework\TestCase;

class HtmlTreeNodeRendererTest extends TestCase
{
    private HtmlTreeNodeRenderer $renderer;

    protected function setUp(): void
    {
        $this->renderer = new HtmlTreeNodeRenderer();
    }

    public function testRenderSimpleNode(): void
    {
        $node = new SimpleNode('Test Node');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('<input type="checkbox">', $html);
        $this->assertStringContainsString('Test Node', $html);
        $this->assertStringNotContainsString('<ul>', $html);
        $this->assertStringNotContainsString('<button>', $html);
    }

    public function testRenderButtonNode(): void
    {
        $node = new ButtonNode('Test Node', 'Click Me');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('<input type="checkbox">', $html);
        $this->assertStringContainsString('Test Node', $html);
        $this->assertStringContainsString('<br/>', $html);
        $this->assertStringContainsString('<button>', $html);
        $this->assertStringContainsString('Click Me', $html);
    }

    public function testRenderButtonNodeWithAction(): void
    {
        $node = new ButtonNode('Test Node', 'Click Me', 'alert("test")');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('onclick="alert(&quot;test&quot;)"', $html);
        $this->assertStringContainsString('Click Me', $html);
    }

    public function testRenderSimpleNodeWithChildren(): void
    {
        $parent = new SimpleNode('Parent');
        $child = new SimpleNode('Child');
        $parent->addChild($child);
        
        $html = $this->renderer->render($parent);
        
        $this->assertStringContainsString('<div>', $html);
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('<ul>', $html);
        $this->assertStringContainsString('<li>', $html);
        $this->assertStringContainsString('Child', $html);
    }

    public function testRenderButtonNodeWithChildren(): void
    {
        $parent = new ButtonNode('Parent', 'Parent Button');
        $child = new SimpleNode('Child');
        $parent->addChild($child);
        
        $html = $this->renderer->render($parent);
        
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Parent Button', $html);
        $this->assertStringContainsString('Child', $html);
        $this->assertStringContainsString('<ul>', $html);
        $this->assertStringContainsString('<li>', $html);
    }

    public function testRenderWithNestedChildren(): void
    {
        $root = new SimpleNode('Root');
        $parent = new ButtonNode('Parent', 'Parent Button');
        $child = new SimpleNode('Child');
        
        $parent->addChild($child);
        $root->addChild($parent);
        
        $html = $this->renderer->render($root);
        
        $this->assertStringContainsString('Root', $html);
        $this->assertStringContainsString('Parent', $html);
        $this->assertStringContainsString('Parent Button', $html);
        $this->assertStringContainsString('Child', $html);
        $this->assertEquals(2, substr_count($html, '<ul>'));
    }

    public function testHtmlEscaping(): void
    {
        $node = new SimpleNode('<script>alert("xss")</script>');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;', $html);
        $this->assertStringNotContainsString('<script>', $html);
    }

    public function testButtonTextEscaping(): void
    {
        $node = new ButtonNode('Test', '<script>alert("xss")</script>');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;', $html);
        $this->assertStringNotContainsString('<script>', $html);
    }

    public function testButtonActionEscaping(): void
    {
        $node = new ButtonNode('Test', 'Click Me', '<script>alert("xss")</script>');
        $html = $this->renderer->render($node);
        
        $this->assertStringContainsString('onclick="&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;"', $html);
        $this->assertStringNotContainsString('<script>', $html);
    }
} 