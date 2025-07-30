<?php

declare(strict_types=1);

namespace App\Domain\Tree;

class SimpleNode implements TreeNode
{
    private string $name;
    private array $children = [];
    private bool $hasButton;

    public function __construct(string $name, bool $hasButton = false)
    {
        $this->name = $name;
        $this->hasButton = $hasButton;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function render(): string
    {
        $html = '<div><input type="checkbox"> ' . htmlspecialchars($this->name);
        
        if ($this->hasButton) {
            $html .= ' <br/> <button> Test Btn </button>';
        }
        
        $html .= '</div>';
        
        if ($this->hasChildren()) {
            $html .= '<ul>';
            foreach ($this->children as $child) {
                $html .= '<li>' . $child->render() . '</li>';
            }
            $html .= '</ul>';
        }
        
        return $html;
    }

    public function addChild(TreeNode $child): void
    {
        $this->children[] = $child;
    }

    public function getChildren(): array
    {
        return $this->children;
    }

    public function hasChildren(): bool
    {
        return !empty($this->children);
    }

    public function hasButton(): bool
    {
        return $this->hasButton;
    }
} 