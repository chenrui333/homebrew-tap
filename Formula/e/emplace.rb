class Emplace < Formula
  desc "Synchronize installed packages on multiple machines"
  homepage "https://github.com/tversteeg/emplace"
  url "https://github.com/tversteeg/emplace/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c50c085e75bb0c4ad6fb5d5baabf94bc74080499d74fd7072fee9b17041e8586"
  license "AGPL-3.0-or-later"
  head "https://github.com/tversteeg/emplace.git", branch: "master"

  depends_on "rust" => :build

  # time crate patch for rust 1.80+, upstream pr ref, https://github.com/tversteeg/emplace/pull/397
  patch do
    url "https://github.com/tversteeg/emplace/commit/ea39f5826f6d0501aa3073f620b8a764900d3dc5.patch?full_index=1"
    sha256 "d203be4401956ccdf38de75c503ae215a91e4ea8a1be0aed1de07ef248a67f01"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emplace --version")

    output = shell_output("#{bin}/emplace config --path")
    assert_match "Your config path", output
  end
end
