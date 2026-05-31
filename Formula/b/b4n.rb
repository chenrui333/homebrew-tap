class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "7c63f747ccc22ffb4f052c9de30c17c8cb126f820bb3e87d5264a874544b0902"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3da24ba200bef82d06c37c8953b7ff4c8fa15e9d0eca8f42246fd01e0e928a6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96a89ada41ea3680c3fe2479b311582fe9db01ea8eb3f017907d098c1ef8e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946fee1adee75a126dfdabcfa04f5ee4fbed77cf4bcab2f52d153a580164a37d"
    sha256 cellar: :any,                 arm64_linux:   "e0c682b2ba7396296bd21f027b1b1fd30b5967ac5b513b4f53c33eac570ff74b"
    sha256 cellar: :any,                 x86_64_linux:  "f5144c4fe730a30ddeaed70a714ce1ac99383d3c2c6811a0188a932c627547e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
