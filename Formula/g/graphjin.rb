class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.12.tar.gz"
  sha256 "5a1a94091a3b5582026c9bf0bcb816efa64591f8966cbfb5a68816ca0c75da16"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68d9f47721bde074206e1d795e30f415e99b3fcaf868ae4b0839474039bb609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac221536b2089ad520db4dac360ddb402e864d8e1786dc1e48e9c64d61b72ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c22d0e105cf0e92e16aab2f2060cc289831071b9c40bd1bd87669e5f7023e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993e041a92636ffc06f4dc3f4d57f0570924a11bde1bb7adf2b898e01145f98d"
    sha256 cellar: :any,                 x86_64_linux:  "1e18370da424eb9f292748d99458458adc33df3696c924cec4a8c48e0a2ba483"
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
