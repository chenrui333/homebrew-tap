class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "8a7c3a6c0b74d1f702eac5d510e757deefd6ec227e1a8d5eb7082b07fd32e273"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98354377fe83c8b4f23f88a9e82616d034269762f37982bd6ef7eb5b41238416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98354377fe83c8b4f23f88a9e82616d034269762f37982bd6ef7eb5b41238416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98354377fe83c8b4f23f88a9e82616d034269762f37982bd6ef7eb5b41238416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5885161d2b9f332ec0449cbf2127bd435d8e98d5d53fc2127af82b85b679700f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a032aedc0395f43cad65eae6d81ce9be805724da121b0443226ef806f6fbefce"
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
