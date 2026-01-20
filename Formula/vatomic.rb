class Vatomic < Formula
  desc "vatomic is a header library of atomics operations, supporting ARM, RISC-V, x86_64"
  homepage "https://github.com/open-s4c/vatomic"
  url "https://github.com/open-s4c/vatomic/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3af8913059bf52c9d269e4a9cb11b81a82c02ea6547946a11b8fb8f3a5c9d10e"
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
