class Spectatui < Formula
  desc "Terminal dashboard for GitHub Spec-Kit"
  homepage "https://github.com/tinesoft/spectatui"
  url "https://github.com/tinesoft/spectatui/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "73255d747dc31fc97b78d6a52750aaa7fedb4fcda85861a9b3bddc22e08986d4"
  license "MIT"
  head "https://github.com/tinesoft/spectatui.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3ff2e325789cab483945f117c162c3e5568924eef477944e4bcf96a7ef17b14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37bcd99fa92af8ca11bbf2653b3893acf1e48cd942eb087de85663c4a03c8921"
    sha256 cellar: :any,                 arm64_linux:   "43d0a4fca4c61f8e064e1e34354fffa8db501498932de08ce17a0f3b6ff6a35e"
    sha256 cellar: :any,                 x86_64_linux:  "c3b8f4e7985bf2d526e6d88e246bb0b8759b3c6ed61306284c90381c53df5193"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/spectatui")
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/spectatui --project #{testpath}/missing 2>&1", 1)
    assert_match "failed to discover project", output
    assert_match "project root not found", output
  end
end
