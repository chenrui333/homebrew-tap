class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.4.tar.gz"
  sha256 "39fcdd659b0458eca6c7154dcb52c9c5d9b7f79f59b407e28aa1407faed01ac3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be5243306be9f601f1d0d204e61ac793aceae0307b0c2ade1b56af960c870e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dada513182cf16537f58628eef6a5c02a8f7b8a5f276728c0bff4d5b2c90a961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cca590b7e6ef143da445d00543d5f1d2f38d27fa5ae87c88ef2b666e6e496d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99130c87e78b3c2d46f70b187bac73cacbe0ce06bdc41f4d298a96c0f48b760a"
    sha256 cellar: :any,                 x86_64_linux:  "5cc20a46f7cdad0b102a0c6c6731123e272a2e93dcc4e287521e8111b5f95610"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
