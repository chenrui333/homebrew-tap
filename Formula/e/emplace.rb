class Emplace < Formula
  desc "Synchronize installed packages on multiple machines"
  homepage "https://codeberg.org/fosk/emplace"
  url "https://codeberg.org/fosk/emplace/archive/v1.6.0.tar.gz"
  sha256 "cf40269689b5b683fdad2dafb401ebf3eff43e4f6dab113849a3d28563c39d00"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/fosk/emplace.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafcbe921b780e56a3c60245c919c0756a06088c08b871eaeba7d66ce5fbfd00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "997b22993ed02ec5d12ebdda8b5b2ab05050eb4d8879c70735a918ffdbeaa0e5"
    sha256 cellar: :any_skip_relocation, ventura:       "07440dfd76804a78bf12acabf6a6ebc0e005b2e776ada28450f066c4edc55aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b89d713e7d3bd9e007611612826f6382963bce4efdc7cbbce1e4f588ec89c2e"
  end

  depends_on "rust" => :build

  # time crate patch for rust 1.80+, upstream pr ref, https://codeberg.org/fosk/emplace/pull/397
  patch do
    url "https://codeberg.org/fosk/emplace/commit/ea39f5826f6d0501aa3073f620b8a764900d3dc5.patch?full_index=1"
    sha256 "2b040ef1b5cfb96aefa8c17def110562dc4fa280c1e7fa764162c7d3568c6d30"
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
