// sort data locally
void countSort(int* data,int* count,int n,int b,int r){
    int i;
    int m = pow(2,r);
    int *tempCount = malloc(m*sizeof(int));
    int *temp = malloc((n)*sizeof(int));

    for(i=0;i<m;i++){
        count[i]=0;
    }
    for (i=0; i < n; i++){
        count[(data[i] >> b*r) & m-1] += 1;
    }
    tempCount[0] = count[0];
    for(i=1;i<m;i++){
        tempCount[i] = count[i] + tempCount[i-1];
    }
    for (i=n-1;i>=0;i--){
        temp[tempCount[(data[i] >> b*r) & m-1] - 1] = data[i]; 
        tempCount[(data[i] >> b*r) & m-1] -=1;
    }
    for (i=0;i<n;i++){
        data[i] = temp[i];
    }
    free(tempCount);
    free(temp);
}
// sorting in process 0 after data gather
void globalSort(int* data, int* temp_data, int* counts,int local_size, int world_size,int bucket_count){
    int m=0;
    for (int i=0;i<bucket_count;i++){
        for(int k=0;k<world_size;k++){
            for (int l=0;l<counts[k*bucket_count + i];l++){
                data[m] = temp_data[k*local_size + prefixSum(counts+k*bucket_count,i) + l];
                m++;
            }
        }
    }
}