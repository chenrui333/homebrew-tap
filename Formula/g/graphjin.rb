class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.4.tar.gz"
  sha256 "d189381b3f84ff203db625c19d14fc824828eb553d6ebbc593a6d51b0a73492e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e944c81e898a2552c2bf7fd4bfd1a6de19471443ff6ccadac2837511165771b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b63b0e855ede011605aad1d0298a6b3b7a902d52e655bc5a81fb66b10e6900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27b6ca463943a60b63e8967c225dd6322c8f5be9b330cbbc52db3fc242053f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4aa2db856c4bb546b545686d8dc1a71f7d02fb30de4a18002c139ae22a68a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6efc878cbca2da7c7e49d74292ebfd2eee6c0ed999ab429da0d72d8a550d00f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
