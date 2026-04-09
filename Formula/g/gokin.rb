class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "9fcdae0bc348cddf590f2de45450efefee5958a9e86a1a800f28e56302243d15"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f40aeffa75bfb59000313ca5d9ae03efa7fd5901886faf4688c175bc1c18a91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f40aeffa75bfb59000313ca5d9ae03efa7fd5901886faf4688c175bc1c18a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f40aeffa75bfb59000313ca5d9ae03efa7fd5901886faf4688c175bc1c18a91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1542596640b1d736f4dfe37f050e3d060dc936b79da003c2762d5f551360228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace29813fdb436da7a544b9f670a6b73a8902b4d49536a8bf83e261832b18cfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
