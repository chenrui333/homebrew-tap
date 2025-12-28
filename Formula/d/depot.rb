class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "2e69bf9263de9003d934a40887d45c4ceeef1a7339f0ee61e329dd5fdfae7ab6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c512beefcbdccecb9f00537da41339147f2d1cc42e1c1a00fdbb65d2a8fd563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c512beefcbdccecb9f00537da41339147f2d1cc42e1c1a00fdbb65d2a8fd563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c512beefcbdccecb9f00537da41339147f2d1cc42e1c1a00fdbb65d2a8fd563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0aa40e9ec34176604700771bae9ce0b3b713da4a070fcb74e3bf0be2364ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24cca88c06366fb26d91af15c57eff813aff164787102950e39175876b38113"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
