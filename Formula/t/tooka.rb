class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6b22bdf7f44163011676cc6b75b4fb592d9c4ab3da968238a1ff039bf2c24e67"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99b92ad267f4e78213f6b415bc6a9d2e91862133cad37eb673f3403e9f4b2348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "797266806d948d2c198c28a9b5aa09524566eb1c072d80cbc6987bdba5306dc5"
    sha256 cellar: :any,                 arm64_linux:   "57bc73ebcc6b315df9262f50cfdef369c9eb67085c98b4cacb88f5e2729e4026"
    sha256 cellar: :any,                 x86_64_linux:  "63a0cbe09239d4a7350e3c406f7cb1023fa3360e4c68d6dcd25496707f638431"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
