class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "c8784ee56cd59a889faa4a93051cc8efdf12564541e7716807c3662151fb90b0"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca1dc41d3ab50d2389daded4312cdf430104b9e7fb9a8fa4b1904b98d70b298"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a81cbfffe8ba57711a8997b82faa389b2599b5d741b90fba2eed7e93fbb7883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fac5bdd41ea7ab5eb169a0176393327c9800782b13411bdf57ab83fe6d67286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d211b21552bfa30facb2472fe27b3c0775feaf1ed4571598b5487647f1fb37d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8dfa56d0787691048e71870bd8a5fc1383a7f6d17f1b2dbe3e9fc3e16f0889"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
