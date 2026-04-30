class Fnox < Formula
  desc "Encrypted/remote secret manager"
  homepage "https://github.com/jdx/fnox"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "dd0c26925dc439b187aa38613e564f455c01f3122e6a6f7c5bf24ed9fd05efbc"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "490b43718eafacedc31409a3f1007d45315ba558dbaaa98c3763ac6797608134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a3485e5e8049ef2a43032677d9bcd878f70da986d7ea441b336eb395f96926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80b9cda955fd8511017ce8d9676048efdc5284400f41fc3b28860e67f40e6b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd90520b061ca0cbe5e81dc17a7711b893a2ec9bd9438f2d0306820931362fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4b459116bcb60bcc82186ae924aa0e960f00ec2ebba5f91acb9d8807fa7cd5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")
    assert_match "fnox", shell_output("#{bin}/fnox doctor 2>&1", 1)
  end
end
