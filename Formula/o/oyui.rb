class Oyui < Formula
  desc "Terminal merge editor for Git and Jujutsu"
  homepage "https://github.com/emilien-jegou/oyui"
  url "https://github.com/emilien-jegou/oyui/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "19250fe9c858d85051f4dee6c7279188e7298ca64cda5f91bdf8d48e48a618ed"
  license "GPL-3.0-only"
  head "https://github.com/emilien-jegou/oyui.git", branch: "main"

  depends_on "rust" => :build

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
