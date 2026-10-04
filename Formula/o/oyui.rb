class Oyui < Formula
  desc "Terminal merge editor for Git and Jujutsu"
  homepage "https://github.com/emilien-jegou/oyui"
  url "https://github.com/emilien-jegou/oyui/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "19250fe9c858d85051f4dee6c7279188e7298ca64cda5f91bdf8d48e48a618ed"
  license "GPL-3.0-only"
  head "https://github.com/emilien-jegou/oyui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c1357ad114517d5f21bcd5a63526823061fc7403133939ae906e350c9a425d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c9ade368644490f3f85d21599ee60023774ca7e3e19768fd0249331a59af37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4bc8d0670f083701e9d75567f6f5b2cb36dca69bc61a08ba33806537bc9171a"
    sha256 cellar: :any,                 arm64_linux:   "60e8f30307cc46b7bbbc0da19ff94e80d87e1de1954efffe107bf7b3539d862b"
    sha256 cellar: :any,                 x86_64_linux:  "c57ce2b51c94b083b975a822bf91eef66d8dc59ff93f45fc316eba351aa7d37b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The 0.2.1 release retains the 0.2.0 Cargo package version.
    inreplace "crates/oyui/src/cli.rs", "version, about", "version = \"#{version}\", about"
    system "cargo", "install", *std_cargo_args(path: "crates/oyui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oyui --version")
    assert_match "unrecognized subcommand", shell_output("#{bin}/oyui invalid-command 2>&1", 2)
  end
end
