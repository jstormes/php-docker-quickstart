<?php

declare(strict_types=1);

namespace App\Domain\Tree;

interface TreeNodeRenderer
{
    public function render(TreeNode $node): string;
} 