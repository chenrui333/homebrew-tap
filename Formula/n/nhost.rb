class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://github.com/nhost/nhost"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "adb9cf2e6d2fabc81687c97559f1ab62e7373947667b582f1dc5ff93bc972713"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9afd4a4cafae35eb1a4dda3ca43c2628a3c24964f07df9b49735f611cb14cca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b43970fac9299314eec9406fb48f34dac34b7778185146a8ca2c362fa2fd780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829b482354937f81b5ab1320956193094a5266a7ddc63cb5540be07f98604a42"
    sha256 cellar: :any,                 x86_64_linux:  "6b94b9b1dd2f3d5e26d3a436aabf72fd226b377b53c86cfb5623bf89cd74eecf"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    # `nhost init` downloads email templates from GitHub; `config default` writes the same local config offline.
    assert_match "Successfully generated default configuration",
                 shell_output("#{bin}/nhost config default 2>&1")
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
    assert_path_exists testpath/".secrets"
    assert_match "Configuration is valid", shell_output("#{bin}/nhost config validate 2>&1")
    assert_match "adminSecret = 'nhost-admin-secret'", shell_output("#{bin}/nhost config show")
  end
end
