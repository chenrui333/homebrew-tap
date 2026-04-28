class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c6d0bb49be40186543451f67356581eab488f888188ddf84678feafeec19db27"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d932ee47a8050fea3e242efa3af2db4f5c024e0c6f25e0e18298e7a531a6a72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8af5b40e43e295d219d5dd22246673d38e80e25d71cf961ecb73912c828ac8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1ad7362502352f626d42f2b8baf78f8a40e24bfe6fef929b41f217df707f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9109df788089df27482038313fb8c7da9c556bf9b88133a6df5d7fdb6dce57de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569c5494f9474133c47c36e16933c194515b567a2093a688d03ce5f04d9c339a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotstate", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotstate --version")
    assert_match "No files are currently synced", shell_output("#{bin}/dotstate list")
  end
end
