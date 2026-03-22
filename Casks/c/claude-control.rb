cask "claude-control" do
  arch arm: "-arm64", intel: ""

  version "0.8.3"
  sha256 arm:   "10c29e4236a31114af36be98e7668d0e6c60af516a14deef8d6e351358cb98bb",
         intel: "8d5584f96e1dc0bcc56fb42e4f08e1f457f494d1b80a673adcd7d4406f5ef06b"

  url "https://github.com/sverrirsig/claude-control/releases/download/v#{version}/Claude.Control-#{version}#{arch}.dmg"
  name "Claude Control"
  desc "Desktop dashboard for monitoring and managing Claude Code sessions"
  homepage "https://github.com/sverrirsig/claude-control"

  depends_on macos: ">= :monterey"

  app "Claude Control.app"
end
