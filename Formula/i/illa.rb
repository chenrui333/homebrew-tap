class Illa < Formula
  desc "Deploy a modern low-code platform in 5 Seconds"
  homepage "https://github.com/illacloud/illa"
  url "https://github.com/illacloud/illa/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "4f39ae2a9a4f3287510f509a2abb1b4c658a0258e0fefd6fc276a74d0c1d3a21"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924351e2e08c327bbdcfc5794b88ed6d52317d6cd900eb6f2cc62e832882ae69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c8d2c049bd1b4cbca5049ecd68df7fab12a49345eabb30992713f7187293760"
    sha256 cellar: :any_skip_relocation, ventura:       "feaab96243d654bff20d010904883cb65a68a554678b0efd41eed2eee7ebed7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a42c5c77fa7cedcf45afb35cce6b304038ea4cc2773625fe859796fb1cbddaf"
  end

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "1.2.14", version.to_s

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/illa --version")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/illa list --self 2>&1", ret_status)
    assert_match <<~EOS, output
      +----+------+-------+-------+
      | ID | Name | Image | State |
      +----+------+-------+-------+
    EOS
  end
end
