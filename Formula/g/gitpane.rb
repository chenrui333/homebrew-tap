class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "c95cc60ac2e1785b9150e995c71dff9bc42be0a70a34291fb6399bf6ffcd7b93"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "ac629e115e6a31f9d2f607bf1f90cb552c212c779156fa00f97e26b82b47fc2f"
    sha256               arm64_sequoia: "8b9b2a21f9711a01b5e55bb03c4c49f3e8fb6b3be5b34fe65a187f410bf68cb6"
    sha256               arm64_sonoma:  "75d7752dea993e33940c501f1f793c09bfd140f7bf04f77a2ce3b9087e41b8cd"
    sha256 cellar: :any, arm64_linux:   "0baa51bdb09554e41c06a3313464d9969e6b775543e6b5e36099f1710864eabb"
    sha256 cellar: :any, x86_64_linux:  "03c9056a5db56c349cfbf464a7f91254e278627c826d5acced976400197c0bc5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
