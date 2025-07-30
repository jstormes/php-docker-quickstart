<?php

declare(strict_types=1);

namespace App\Domain\Tree;

class ButtonNode extends AbstractTreeNode
{
    private string $buttonText;
    private string $buttonAction;

    public function __construct(string $name, string $buttonText = 'Test Btn', string $buttonAction = '')
    {
        parent::__construct($name);
        $this->buttonText = $buttonText;
        $this->buttonAction = $buttonAction;
    }

    public function getType(): string
    {
        return 'button';
    }

    public function getButtonText(): string
    {
        return $this->buttonText;
    }

    public function getButtonAction(): string
    {
        return $this->buttonAction;
    }
} 