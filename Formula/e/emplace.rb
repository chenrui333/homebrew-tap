class Emplace < Formula
  desc "Synchronize installed packages on multiple machines"
  homepage "https://github.com/tversteeg/emplace"
  url "https://github.com/tversteeg/emplace/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c50c085e75bb0c4ad6fb5d5baabf94bc74080499d74fd7072fee9b17041e8586"
  license "AGPL-3.0-or-later"
  head "https://github.com/tversteeg/emplace.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafcbe921b780e56a3c60245c919c0756a06088c08b871eaeba7d66ce5fbfd00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "997b22993ed02ec5d12ebdda8b5b2ab05050eb4d8879c70735a918ffdbeaa0e5"
    sha256 cellar: :any_skip_relocation, ventura:       "07440dfd76804a78bf12acabf6a6ebc0e005b2e776ada28450f066c4edc55aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b89d713e7d3bd9e007611612826f6382963bce4efdc7cbbce1e4f588ec89c2e"
  end

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
