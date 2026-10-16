class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "7c24bccc0c8ab723343bc3038d03b806039dbedb9fa7512f4bb34f858fb35519"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8f824335d9918e93049d4a747a7b122546725d991621827f2378021e380305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8f824335d9918e93049d4a747a7b122546725d991621827f2378021e380305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63ec42b5dc6f12024f6fe247a3a43662c1fb57e6f436c71937c20630d3375948"
    sha256 cellar: :any,                 x86_64_linux:  "37b66e55386c7e582e49102c60fa61ebfdcce83a9ba22816ea2f168b029ac66d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
