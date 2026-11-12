class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "290b7db32efe4c93ada6b73c8034fdb0de1f78fce825cda9dc19f1997f3ceffe"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dad29eb44dd9f8827144c8a1b87fe1ad2554005c3ab56b96a5508c6ea0366539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad29eb44dd9f8827144c8a1b87fe1ad2554005c3ab56b96a5508c6ea0366539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a62c07868228cee9e8a2d3ef21eeb9f2b5f8a335c0c20eb8ee9a88ff001833"
    sha256 cellar: :any,                 x86_64_linux:  "05e23cc8e33cd4a8861f5c586afd63089e46ce6a913a4ef7ff50827638ac62d0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/kopecmaciej/vi-mongo/internal/build.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"vi-mongo"} --version")

    output = shell_output("#{bin/"vi-mongo"} --connection-list")
    assert_match "connection", output.downcase
  end
end
