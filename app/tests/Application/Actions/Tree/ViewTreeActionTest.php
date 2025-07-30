<?php

declare(strict_types=1);

namespace App\Tests\Application\Actions\Tree;

use App\Application\Actions\Tree\ViewTreeAction;
use App\Domain\Tree\SimpleNode;
use PHPUnit\Framework\TestCase;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\StreamInterface;
use Psr\Log\LoggerInterface;

class ViewTreeActionTest extends TestCase
{
    private ViewTreeAction $action;
    private ServerRequestInterface $request;
    private ResponseInterface $response;
    private StreamInterface $stream;
    private LoggerInterface $logger;

    protected function setUp(): void
    {
        $this->request = $this->createMock(ServerRequestInterface::class);
        $this->response = $this->createMock(ResponseInterface::class);
        $this->stream = $this->createMock(StreamInterface::class);
        $this->logger = $this->createMock(LoggerInterface::class);
        
        $this->action = new ViewTreeAction($this->logger);
    }

    public function testActionReturnsHtmlResponse(): void
    {
        $this->response->expects($this->once())
            ->method('getBody')
            ->willReturn($this->stream);

        $this->response->expects($this->once())
            ->method('withHeader')
            ->with('Content-Type', 'text/html')
            ->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, '<!DOCTYPE html>') &&
                       str_contains($html, '<title>Composite Pattern Tree</title>') &&
                       str_contains($html, 'Composite Pattern Tree Implementation');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlContainsTreeStructure(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, 'Main') &&
                       str_contains($html, 'Sub-1') &&
                       str_contains($html, 'Sub-2') &&
                       str_contains($html, 'Sub-2-1') &&
                       str_contains($html, 'Sub-2-2');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlContainsCss(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, '<style>') &&
                       str_contains($html, '.tree ul') &&
                       str_contains($html, '.tree li') &&
                       str_contains($html, 'float: left') &&
                       str_contains($html, 'text-align: center');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlContainsButtonForMainNode(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, 'Test Btn') &&
                       str_contains($html, '<button>');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlHasProperStructure(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, '<html lang="en">') &&
                       str_contains($html, '<head>') &&
                       str_contains($html, '<body>') &&
                       str_contains($html, '<div class="tree">') &&
                       str_contains($html, '<ul>') &&
                       str_contains($html, '<li>');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlContainsCheckboxes(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                return str_contains($html, '<input type="checkbox">');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }

    public function testGeneratedHtmlIsValidHtml(): void
    {
        $this->response->method('getBody')->willReturn($this->stream);
        $this->response->method('withHeader')->willReturnSelf();

        $this->stream->expects($this->once())
            ->method('write')
            ->with($this->callback(function ($html) {
                // Basic HTML validation
                return str_contains($html, '<!DOCTYPE html>') &&
                       str_contains($html, '<html') &&
                       str_contains($html, '</html>') &&
                       str_contains($html, '<head>') &&
                       str_contains($html, '</head>') &&
                       str_contains($html, '<body>') &&
                       str_contains($html, '</body>');
            }));

        $this->action->__invoke($this->request, $this->response, []);
    }
} 