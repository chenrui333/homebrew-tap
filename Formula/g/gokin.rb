class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.56.7.tar.gz"
  sha256 "799bc2cd9048a8db1e4c7226ac3bc26f42edb5760ecbfc95e01eaedf43a63da9"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4163fdb9f0260d93e7368f68efa6ed7f0ba9a65f1ad9cf5ec5c99b4f751381d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4163fdb9f0260d93e7368f68efa6ed7f0ba9a65f1ad9cf5ec5c99b4f751381d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4163fdb9f0260d93e7368f68efa6ed7f0ba9a65f1ad9cf5ec5c99b4f751381d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f536176701a913b8456ea7d5ddf0917aa3d28e811141484142f8af1e4861eb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af5e264ebc102b28c6440755fb20b23aa692e2c9f4fa96f3e807fe537c7f84a"
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
