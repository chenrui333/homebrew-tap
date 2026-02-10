class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "c5a3226d659f891ab0add85e25e026f40486e359f015388f602bb40264ed57f7"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912fae7fc1e999d625529fb3252942e6efc2c844e13b3c48fea262bfb2847bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453c973fe0da42c18bb4c9d8704799d893d468a9d5dd8b19e3b17e1f72f2b5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1128cf8baafffd7264c4e6b90440656ea341f5faa9a350cd4b833ec355711de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a1a4c10cfcf029f5e6cdad7918a854c055f4b8af988fa2cb42a37d64306eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a5f6d8f15385c30e33540ca8066b6305fa7fd4b357e5e0378f7af3d8e088c6b"
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
