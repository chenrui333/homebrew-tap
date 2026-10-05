class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "49dc29635990385fef22717d23c986a62803dc2afeeb428e0a1910711b169c37"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e27f2016130bcd8df2989c06fe637151a79a6735ccc7cb17314e943e30b804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e27f2016130bcd8df2989c06fe637151a79a6735ccc7cb17314e943e30b804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cefa5c5ea13493af858579c3c041d5d14f3840991ccac74184f1a8646cfae4ec"
    sha256 cellar: :any,                 x86_64_linux:  "91a1933f48fe29a46ca2183c0af11586311723960da264a92996995fc923683a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/lazymake --not-a-real-option 2>&1", 1)
    assert_match "unknown flag: --not-a-real-option", output
  end
end
