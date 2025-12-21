class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "38ced0ccf3d3f2dd1a80d199fe771be522543d3ae609e396f3525e40554312b7"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b3ea8b5aa0af0489b09dcd39886f2fa566f1ef181cbac7f3f5f582ae553b780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc545da25216b70b2901bc9300024eeff1ba327dc7d20bbdc8b30a513078e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249fd26b6d0d855b476dc86db49e09a100d367d168757e741caff4edd016182f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379c7082d6e19561070ef562dd642ef157486694dc978e7c9cd9b1bee4806c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b2b40fe5a61830b5d5066d61ed26a1e2a3b1758a58d48fc74e525f55e33690"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
