class SpaceliftIntent < Formula
  desc "Provision and manage cloud infrastructure using natural language"
  homepage "https://spacelift.io/intent"
  url "https://github.com/spacelift-io/spacelift-intent/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "523f345e29949b61b47683fbf892431cfd83e907a43a6d023a1b32745dce7006"
  license "Apache-2.0"
  head "https://github.com/spacelift-io/spacelift-intent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ce322e58b4072414c5180ef9a9b82aaf7a85c6c416aa622c26bab35cecdb7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf224851ecc1c70c7a345b8b76bea41e62ab447cb4dc5bd3895e6b4695e3837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca450a4e61d091202795ceb08827aa6cb5aba5bed61ff10e2bf5863909172938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da7ac383cd8e598a80c1868a163c975e8ae28e7d50d473286dd4a47a008c787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686e8b881660944e67b6dd2b559019e966fc280cfd9ef3edef50dccc413a4397"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spacelift-intent"
  end

  test do
    require "open3"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = +""
    Open3.popen2e(bin/"spacelift-intent") do |stdin, stdout_err, wait_thread|
      stdin.write json
      stdin.close

      deadline = Time.now + 10
      until output.include?("# Infrastructure Management - Essential Instructions") || Time.now > deadline
        break unless stdout_err.wait_readable(0.5)

        output << stdout_err.readpartial(1024)
      end

      Process.kill("TERM", wait_thread.pid) if wait_thread.alive?
    end

    assert_match "# Infrastructure Management - Essential Instructions", output
  end
end
