class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "88183f8bc021537e256b63a05da5a9496d33d7087d5f8c71405a48857e505510"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9b8f40a87a456416453bc78eaf4dae87117b65e3e5be5b0a5ee9a31ab8c1bf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499991368be498be31d2dde551ac605c1a6dc67fb724406ec4595e54e9ffc026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d41a0678651d0b982beb7659b09f4d709766a3509a321c7da6213fa2caae9b3f"
    sha256 cellar: :any,                 arm64_linux:   "c572f199086e26ce7439fe9271401a2af7e418cb262626e7c3c2650ccfdbc8f9"
    sha256 cellar: :any,                 x86_64_linux:  "3e16d95b832333cf1fd016f7dde07c5cfb003874f8c1c9d767c24265023efebf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
