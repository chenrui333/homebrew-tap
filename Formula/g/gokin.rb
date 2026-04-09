class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "9fcdae0bc348cddf590f2de45450efefee5958a9e86a1a800f28e56302243d15"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b66f9e9deb527d54487511bf51c36c24979db73dca35febf6a72abb0b8f25dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b66f9e9deb527d54487511bf51c36c24979db73dca35febf6a72abb0b8f25dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b66f9e9deb527d54487511bf51c36c24979db73dca35febf6a72abb0b8f25dcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd863c39dff844eed194542331668683d780553783bbd5844a8a8f167925652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b1646b9129277b0e127795134d95aaba18b23146218d96f3010f22aac6997d"
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
