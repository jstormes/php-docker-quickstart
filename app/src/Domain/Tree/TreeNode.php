<?php

declare(strict_types=1);

namespace App\Domain\Tree;

interface TreeNode
{
    public function getName(): string;
    public function addChild(TreeNode $child): void;
    public function getChildren(): array;
    public function hasChildren(): bool;
    public function getType(): string;
} 