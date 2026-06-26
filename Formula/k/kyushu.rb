class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.1.0.tar.gz"
  sha256 "0fccf800b577b5f5dbf0504d852ed0061ca2a07d52ac563204cb1b22c5f8f711"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879e87c2c7a24284fe06d21a8bbfe262f03e35010814637a6738e5f354fe87ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936d0a3d6fe5a50f7786f0d362d6bc63450959971116dacd4937a95515aca724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5fd4fd9a4512c9a9aee02536d7ee81d199a2653e4909dc8605a7c4878248086"
    sha256 cellar: :any,                 arm64_linux:   "250ff7811323399dd9d84cacd1331fdc926bbca1a5c0f6516f2ea7b90ee6ac60"
    sha256 cellar: :any,                 x86_64_linux:  "6fcd65ce286b97cba7cda58b2a6de654e3fb3d71f0aa32b8a00761913796d03b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
