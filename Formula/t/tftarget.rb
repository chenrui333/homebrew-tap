# framework: cobra
class Tftarget < Formula
  desc "Interactivity select resource to ( plan | apply | destroy ) with target option"
  homepage "https://github.com/future-architect/tftarget"
  url "https://github.com/future-architect/tftarget/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "c68ad9cc23f0ae1ac735dc74e98e340512be6b3ba4dd5cf2925caf6f5cb1cc13"
  license "MIT"
  head "https://github.com/future-architect/tftarget.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c898ef86fa7f468d632ec26ffdf4b37613a86e12dfdf6d339fa39969ab09f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c898ef86fa7f468d632ec26ffdf4b37613a86e12dfdf6d339fa39969ab09f95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "037dce958459abb9f011e6e3f2d24088894158c3014696ef7c83b2228709fc86"
    sha256 cellar: :any,                 x86_64_linux:  "d69173473e39c8d4e5887eb29cad97f3a081f17f2f458fc3bb2031bc1bbea0db"
  end

  depends_on "go" => :build
  depends_on "opentofu"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tftarget", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tftarget --version")

    output = shell_output("#{bin}/tftarget plan --executable tofu 2>&1", 1)
    assert_match "Error: No configuration files", output
  end
end
