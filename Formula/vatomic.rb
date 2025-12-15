class Vatomic < Formula
  desc "vatomic is a header library of atomics operations, supporting ARM, RISC-V, x86_64"
  homepage "https://github.com/open-s4c/vatomic"
  url "https://github.com/open-s4c/vatomic/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "54c2ef05123a5d2f12f9638971f1085e7be080aed86cc3d93f76c436f2a1210a"
  license "MIT"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + [
      "-DBUILD_TESTING=OFF"
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vsync/atomic.h>
      #include <stdio.h>

      vatomic32_t count;

      int main() {
        vatomic_inc(&count);
        printf("count: %u\\n", vatomic_read(&count));
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}"

    manpages = Dir[Formula["vatomic"].share/"man/**/vatomic*"]
    assert !manpages.empty?, "vatomic manpages were not installed"
  end
end
