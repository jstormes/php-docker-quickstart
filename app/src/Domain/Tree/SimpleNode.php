<?php

declare(strict_types=1);

namespace App\Domain\Tree;

class SimpleNode extends AbstractTreeNode
{
    public function getType(): string
    {
        return 'simple';
    }
} 