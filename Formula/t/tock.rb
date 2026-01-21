class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "bd43b2d3e59845cde23de2930b5e9067ca7a4113b28dc2a04b02b635b743032c"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eca4efcc09418546a77344a6ecdf31ae54f2a7d0992164b961db2819795b71a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca4efcc09418546a77344a6ecdf31ae54f2a7d0992164b961db2819795b71a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eca4efcc09418546a77344a6ecdf31ae54f2a7d0992164b961db2819795b71a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98200a37c7b84160b2832213337e59614089174a1c33a82c247f18ad0df1ada5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c9c9b2dcb9d269afcb738fa4addccaaad1c40975c09a7c792b16aee91185da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
