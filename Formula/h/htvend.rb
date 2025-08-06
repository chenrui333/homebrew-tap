class Htvend < Formula
  desc "Accelerate your Python functions with cloud GPUs"
  homepage "https://github.com/continusec/htvend"
  url "https://github.com/continusec/htvend/archive/690220a47f03ec1306f64efadaf63145c28ec0ca.tar.gz"
  version "0.0.1"
  sha256 "79890c69f1c16e2b16c4f12633dfc652f6e3c8f5a0480be941903d5a5ac5d0ff"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/htvend"
  end

  test do
    output = shell_output("#{bin}/htvend build -- curl https://www.google.com 2>&1")
    assert_match "Fetching URL: https://www.google.com/", output
    assert_path_exists testpath/"assets.json"
  end
end
