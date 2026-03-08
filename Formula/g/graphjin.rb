class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "adbd5c21732c8efc3f0e16ad943f0f5ab258f98493f409fb0bb9521d5d1a820c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d5d5cf3ee5318ebbeb5fccf8cbe3f664ec87791600f3335235a86a7cc8af862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c626a4712b9c54433050d4e16f4a58f080ec1be60f5c4e486fa99cfebe4fe5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f047b4ba6a44fbb0efd8e1d19dc6691dd17aa84cae5d4b18c0be50ba8198467c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3ffad56a4e850cea2aa9532ad136b5c6ba7fd54762105deb560ec1a7913eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a6a01ea19957b6a40f517eaf1b1e6df775e2d2e36c5c5eace0f458a3c70f85"
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
