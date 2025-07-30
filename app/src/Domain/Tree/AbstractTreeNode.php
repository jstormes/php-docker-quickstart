<?php

declare(strict_types=1);

namespace App\Domain\Tree;

abstract class AbstractTreeNode implements TreeNode
{
    protected string $name;
    protected array $children = [];

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
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

    abstract public function getType(): string;
} 