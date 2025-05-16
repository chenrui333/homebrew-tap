class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.7.tar.gz"
  sha256 "3c3e03c435eb19e3cd90116023a3b7f7eeae7fd45e2b06258d70e6aadb507e8a"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bba37c882e47bfbaaac1c31afdb83ae00720ba3151e8acb2892ec82fb2e295c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2470d28b5e36abe2393f53c3f79e58d9405805d2301ae9e9187348861da622"
    sha256 cellar: :any_skip_relocation, ventura:       "696c2bc8946c1d18d79a18e0219f837415b227f58708b1c967cda1563b0e8b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f4f654f795b8743034566c35b5eb21dee61a8581808aa264223909d5364ea9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
