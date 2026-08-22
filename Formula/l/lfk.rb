class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "221310c13e328f98414b2b1875d7738c2e592a8b703ec559d6525f83225e38d9"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7342b99b755a254eeabca644df3229d18d641eeac95536bca508a266e7fee241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7342b99b755a254eeabca644df3229d18d641eeac95536bca508a266e7fee241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7342b99b755a254eeabca644df3229d18d641eeac95536bca508a266e7fee241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf28a9b52166f4c86ff5d93b5c79d4fd9d5204d419a248dbb98a92163ccdbbb"
    sha256 cellar: :any,                 x86_64_linux:  "c19738381160380fe5e5aca8560aac6e5ef746e9649ce6fd1d76e5ba92787d5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
