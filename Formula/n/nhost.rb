class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.9.tar.gz"
  sha256 "d104ae870f3afc2f94bd453423b1e5cf1b4b292a63bf4368a46f559c0ad3b0f6"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0909ca9c50b95ead26ae9c05ee79bc4303c98b2c66d2ca1a1efe4b7fa09f017a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2644eae3748511de6d3acd49e1d675abd86f5912e38772cd5b29df8a96ccace"
    sha256 cellar: :any_skip_relocation, ventura:       "c39fdb627c8e63f02dec31f2ec64fd4fcfc90739762333ee143276eb440766e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b60f32c7305f38950fa2a7a7d10b3d4d4734251dc09b61d3750257e0e2fa198e"
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
