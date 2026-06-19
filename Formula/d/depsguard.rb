class Depsguard < Formula
  desc "Harden your package manager configs against supply chain attacks"
  homepage "https://github.com/arnica/depsguard"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "dcddbf0826245f33efa908a2d24b5c4c78bea587771a44a435a0f739d695587d"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969f237d1d73624ebb86ee24aa7b7688e37482c4e205cfbc1f3c6e2838c6e234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d89185114b0dd14a3e88487a15da7c2155bf62c3344522a87fdec558b670f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4879251696388ff1b229350042cec2c8aaa523fbca77b643830db6697f60eb1b"
    sha256 cellar: :any,                 arm64_linux:   "2267e875717295e3c313e405e523988bd168ae02cbb404e193d385afe13fb377"
    sha256 cellar: :any,                 x86_64_linux:  "ad53d205b2240b30c0b668efeb6665911ccf87336c976421f4a9df0b847ddcea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")
    output = shell_output("#{bin}/depsguard --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
